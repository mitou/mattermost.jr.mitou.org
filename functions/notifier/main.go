package notifier

import (
	"context"
	"encoding/json"
	"log"
	"os"
	"strings"
	"time"

	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"github.com/cloudevents/sdk-go/v2/event"
	"github.com/nafisfaysal/matterhook"
)

func init() {
	functions.CloudEvent("Notify", notify)
}

// MessagePublishedData contains the full Pub/Sub message
// See the documentation for more details:
// https://cloud.google.com/eventarc/docs/cloudevents#pubsub
type MessagePublishedData struct {
	Message PubSubMessage
}

// PubSubMessage is the payload of a Pub/Sub event.
// See the documentation for more details:
// https://cloud.google.com/pubsub/docs/reference/rest/v1/PubsubMessage
type PubSubMessage struct {
	Data []byte `json:"data"`
}

func notify(ctx context.Context, e event.Event) error {
	var msg MessagePublishedData
	if err := e.DataAs(&msg); err != nil {
		return err
	}
	payload := string(msg.Message.Data)
	webhookUrl, found := os.LookupEnv("WEBHOOK_URL")
	if !found {
		log.Printf("Failed to get WEBHOOK_URL environment variable")
		return nil
	}

	notification, err := decodeCloudMonitoringJson(payload)
	if err != nil {
		log.Printf("Failed to decode notification data\n%v", err)
		return nil
	}
	return matterhook.Send(webhookUrl, *generateMattermostMessage(notification))
}

func decodeCloudMonitoringJson(payload string) (*CloudMonitoringIncidentNotification, error) {
	var notification CloudMonitoringIncidentNotification
	err := json.Unmarshal([]byte(payload), &notification)
	if err != nil {
		return nil, err
	}
	return &notification, nil
}

func generateMattermostMessage(notification *CloudMonitoringIncidentNotification) *matterhook.Message {
	var msg matterhook.Message
	timeLayout := "2006-01-02 15:04:05"
	startedAt := time.Unix(int64(notification.Incident.StartedAt), 0).UTC()
	endedAt := time.Unix(int64(notification.Incident.EndedAt), 0).UTC()
	color := "#333333"
	if strings.ToUpper(notification.Incident.State) == "OPEN" {
		color = "#FF0000"
	}
	msg.AddAttachment(matterhook.Attachment{
		Title:     "Alert triggered by Cloud Monitoring",
		Text:      notification.Incident.Summary,
		Color:     color,
		TitleLink: notification.Incident.Url,
		Fields: []matterhook.Field{
			{
				Title: "Status",
				Value: notification.Incident.State,
			},
			{
				Title: "Incident ID",
				Value: notification.Incident.IncidentId,
				Short: true,
			},
			{
				Title: "Started at(UTC)",
				Value: startedAt.Format(timeLayout),
				Short: true,
			},
			{
				Title: "Ended at(UTC)",
				Value: endedAt.Format(timeLayout),
				Short: true,
			},
		},
	})
	return &msg
}

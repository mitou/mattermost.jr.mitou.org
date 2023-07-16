package notifier

type CloudMonitoringIncidentNotification struct {
	Version  string                   `json:"version"`
	Incident *CloudMonitoringIncident `json:"incident"`
}

type CloudMonitoringIncident struct {
	IncidentId string `json:"incident_id"`
	Url        string `json:"url"`
	StartedAt  int    `json:"started_at"`
	EndedAt    int    `json:"ended_at"`
	State      string `json:"state"`
	Summary    string `json:"summary"`
}

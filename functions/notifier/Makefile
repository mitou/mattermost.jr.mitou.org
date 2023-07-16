deploy:
	gcloud functions deploy notifier --retry --runtime=go120 --region=asia-northeast1 --source=. --entry-point=Notify --trigger-topic=mattermost-alert
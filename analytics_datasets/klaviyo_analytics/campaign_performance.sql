CREATE TABLE analytics_klaviyo.campaign_performance
ENGINE = ReplacingMergeTree()
ORDER BY (campaign_id, assumeNotNull(sent_date))
AS
SELECT
    c.id as campaign_id,
    c.campaign_name,
    c.status,
    c.channel,
    assumeNotNull(toDate(c.send_time)) as sent_date,
    -- Email metrics from events
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Received Email')) as emails_sent,
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Opened Email')) as emails_opened,
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Clicked Email')) as emails_clicked,
    countIf(e.metric_id IN (SELECT id FROM data_klaviyo.metrics WHERE metric_name = 'Unsubscribed')) as unsubscribes,
    -- Calculate rates
    if(emails_sent > 0, emails_opened / emails_sent, 0) as open_rate,
    if(emails_opened > 0, emails_clicked / emails_opened, 0) as click_to_open_rate,
    if(emails_sent > 0, emails_clicked / emails_sent, 0) as click_rate
FROM data_klaviyo.campaigns c
LEFT JOIN data_klaviyo.events e ON toDate(e.event_datetime) = toDate(c.send_time)
WHERE c.status = 'Sent' AND c.send_time IS NOT NULL
GROUP BY c.id, c.campaign_name, c.status, c.channel, sent_date;
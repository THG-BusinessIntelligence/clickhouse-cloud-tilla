-- 1. Daily Active Users
INSERT INTO data_ga4.daily_active_users
SELECT toDate(date) as date, toDate(endDate) as endDate, toDate(startDate) as startDate, property_id, active1DayUsers
FROM raw_ga4.daily_active_users;

-- 2. Devices
INSERT INTO data_ga4.devices
SELECT toDate(date) as date, browser, toDate(endDate) as endDate, newUsers, sessions, toDate(startDate) as startDate, bounceRate, totalUsers, property_id, deviceCategory, operatingSystem, screenPageViews, sessionsPerUser, averageSessionDuration, screenPageViewsPerSession
FROM raw_ga4.devices;

-- 3. Four Weekly Active Users
INSERT INTO data_ga4.four_weekly_active_users
SELECT toDate(date) as date, toDate(endDate) as endDate, toDate(startDate) as startDate, property_id, active28DayUsers
FROM raw_ga4.four_weekly_active_users;

-- 4. Locations
INSERT INTO data_ga4.locations
SELECT city, toDate(date) as date, region, country, toDate(endDate) as endDate, newUsers, sessions, toDate(startDate) as startDate, bounceRate, totalUsers, property_id, screenPageViews, sessionsPerUser, averageSessionDuration, screenPageViewsPerSession
FROM raw_ga4.locations;

-- 5. Pages
INSERT INTO data_ga4.pages
SELECT toDate(date) as date, toDate(endDate) as endDate, hostName, toDate(startDate) as startDate, bounceRate, property_id, screenPageViews, pagePathPlusQueryString
FROM raw_ga4.pages;

-- 6. Traffic Sources
INSERT INTO data_ga4.traffic_sources
SELECT toDate(date) as date, toDate(endDate) as endDate, newUsers, sessions, toDate(startDate) as startDate, bounceRate, totalUsers, property_id, sessionMedium, sessionSource, screenPageViews, sessionsPerUser, averageSessionDuration, screenPageViewsPerSession
FROM raw_ga4.traffic_sources;

-- 7. Website Overview
INSERT INTO data_ga4.website_overview
SELECT toDate(date) as date, toDate(endDate) as endDate, newUsers, sessions, toDate(startDate) as startDate, bounceRate, totalUsers, property_id, screenPageViews, sessionsPerUser, averageSessionDuration, screenPageViewsPerSession
FROM raw_ga4.website_overview;

-- 8. Weekly Active Users
INSERT INTO data_ga4.weekly_active_users
SELECT toDate(date) as date, toDate(endDate) as endDate, toDate(startDate) as startDate, property_id, active7DayUsers
FROM raw_ga4.weekly_active_users;
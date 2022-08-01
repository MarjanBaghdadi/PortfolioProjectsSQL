SELECT * 
FROM dbo.tweeter

--total tweet counts in each time zone
SELECT user_timezone,  SUM(tweet_count) as sum_tweet_count
FROM dbo.tweeter
WHERE user_timezone IS NOT NULL
GROUP BY user_timezone
ORDER BY user_timezone



--gender of users of tweeter
SELECT gender, user_timezone, SUM(tweet_count) as sum_tweet_count
FROM dbo.tweeter
WHERE gender not in ('NULL', 'brand', 'unknown') AND user_timezone not in ('NULL')
GROUP BY gender, user_timezone


-- How many times the word "war" has been repeated in the contents
SELECT user_timezone, SUM(tweet_count) as total_tweet_counts
FROM dbo.tweeter
WHERE text LIKE '%war%' AND user_timezone not in ('NULL')
GROUP BY user_timezone



-- How many times the word "peace" been repeated in the contents
SELECT user_timezone, SUM(tweet_count) as total_tweet_counts
FROM dbo.tweeter
WHERE text LIKE '%peace%' AND user_timezone not in ('NULL')
GROUP BY user_timezone

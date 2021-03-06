\c hw_joins
-- 1. Get posts containing a specific keyword (e.g. "about").
SELECT * FROM posts WHERE content ILIKE '%about%';

-- 2. Get a listing of all posts grouped by year.
SELECT extract(year from created_at) AS year, posts.title
  FROM posts
  ORDER BY year;

-- 3. Get the top 5 wordiest posts by character count.
SELECT title, char_length(content) AS characters
  FROM posts
  ORDER BY characters DESC LIMIT 5;

-- 4. Find how many comments each user has across all of their posts.
SELECT users.login, COUNT(comments.*) AS total_comments
  FROM users, comments, posts
  WHERE comments.post_id = posts.id AND posts.author_id = users.id
  GROUP BY users.login
  ORDER BY total_comments;

-- 5. Get a specific user's posts sorted by date of most recent comment.
SELECT posts.title, MAX(comments.created_at) AS comments_created_at
  FROM users, posts, comments
  WHERE comments.post_id = posts.id AND posts.author_id = users.id AND users.login = 'Jill'
  GROUP BY posts.title
  ORDER BY comments_created_at DESC;

-- 6. Find how many comments each user has made per post category.
SELECT users.login, categories.name, COUNT(comments.*) AS comments_count
  FROM users, comments, posts, categories
  WHERE comments.author_id = users.id AND comments.post_id = posts.id AND posts.category_id = categories.id
  GROUP BY users.login, categories.name
  ORDER BY users.login;

-- 7. Get the 5 most-commented-on posts that were created in the last 7 days.
SELECT COUNT(comments.*), posts
  FROM posts, comments
  WHERE comments.post_id = posts.id AND posts.created_at > CURRENT_TIMESTAMP - interval '7 days' AND posts.created_at < CURRENT_TIMESTAMP
  GROUP BY posts
  ORDER BY COUNT(comments.*) DESC LIMIT 5;

-- 8. Get the 5 posts with the longest-running comment threads
--    (longest time between first and last comments).
SELECT posts.title, (MAX(comments.created_at) - MIN(comments.created_at)) AS runtime
  FROM posts, comments
  WHERE comments.post_id = posts.id
  GROUP BY posts.title
  ORDER BY runtime DESC LIMIT 5;

-- 9. Get all posts by a specific user that have comments,
--    but which that user hasn't commented on.
SELECT DISTINCT posts.title
  FROM posts, comments
  WHERE comments.post_id = posts.id AND comments.author_id != posts.author_id AND posts.author_id = 13;

-- 10. Find which category of post each user has made the most comments on.
SELECT users.login, MAX(categories.name) AS most_commented_category
  FROM users, comments, posts, categories
  WHERE users.id = comments.author_id AND comments.post_id = posts.id AND posts.category_id = categories.id
  GROUP BY users.login;

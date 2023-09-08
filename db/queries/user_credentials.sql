-- name: CreateUserCredentials :one
INSERT INTO user_credentials (
    user_id,
    username,
    password
)
VALUES (
    $1, $2, $3
)
RETURNING *;

-- name: GetUserCredentials :one
SELECT * FROM user_credentials
WHERE user_id = $1 LIMIT 1;

-- name: ListUserCredentials :many
SELECT * FROM user_credentials
ORDER BY user_id
LIMIT $1
OFFSET $2;

-- name: UpdateUsername :one
UPDATE user_credentials
SET username = $2
WHERE user_id = $1
RETURNING *;

-- name: UpdatePassword :one
UPDATE user_credentials
SET password = $2
WHERE user_id = $1
RETURNING *;

-- name: DeleteUserCredentials :exec
DELETE FROM user_credentials
WHERE user_id = $1;
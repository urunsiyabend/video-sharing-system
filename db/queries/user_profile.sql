-- name: CreateUserProfile :one
INSERT INTO user_profile (
    first_name,
    last_name,
    email,
    created_at
) VALUES (
    $1, $2, $3, $4
) RETURNING *;

-- name: GetUserProfile :one
SELECT * FROM user_profile
WHERE id = $1 LIMIT 1;

-- name: ListUserProfiles :many
SELECT * FROM user_profile
ORDER BY id
LIMIT $1
OFFSET $2;

-- name: UpdateUserProfile :one
UPDATE user_profile
SET first_name = $2, last_name = $3, email = $4
WHERE id = $1
RETURNING *;

-- name: DeleteUserProfile :exec
DELETE FROM user_profile
WHERE id = $1;

CREATE TABLE "user_profile" (
                                "id" bigserial PRIMARY KEY,
                                "first_name" varchar NOT NULL,
                                "last_name" varchar NOT NULL,
                                "email" varchar UNIQUE NOT NULL,
                                "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "user_credentials" (
                                    "user_id" bigserial UNIQUE NOT NULL,
                                    "username" varchar UNIQUE NOT NULL,
                                    "password" varchar NOT NULL,
                                    "last_login" timestamptz
);

CREATE TABLE "channel" (
                           "id" bigserial PRIMARY KEY,
                           "owner_id" bigserial,
                           "name" varchar NOT NULL,
                           "description" text NOT NULL,
                           "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "subscription_plan" (
                                     "id" bigserial PRIMARY KEY,
                                     "channel_id" bigserial NOT NULL,
                                     "name" varchar UNIQUE NOT NULL,
                                     "class" int UNIQUE NOT NULL,
                                     "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "subscription" (
                                "user_id" bigserial NOT NULL,
                                "plan_id" bigserial,
                                "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "post" (
                        "id" bigserial PRIMARY KEY,
                        "title" varchar NOT NULL,
                        "description" text NOT NULL,
                        "thumbnail_url" varchar NOT NULL,
                        "video_url" varchar NOT NULL,
                        "subscription_plan_id" bigserial NOT NULL
);

CREATE TABLE "topic" (
                         "id" bigserial PRIMARY KEY,
                         "name" varchar NOT NULL,
                         "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "post_topic" (
                              "post_id" bigserial NOT NULL,
                              "topic_id" bigserial NOT NULL
);

CREATE TABLE "view" (
                        "viewer_id" bigserial NOT NULL,
                        "post_id" bigserial NOT NULL,
                        "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "comment" (
                           "id" bigserial PRIMARY KEY,
                           "commenter_id" bigserial NOT NULL,
                           "post_id" bigserial NOT NULL,
                           "content" text NOT NULL,
                           "parent_comment_id" bigserial,
                           "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "comment_like" (
                                "id" bigserial PRIMARY KEY,
                                "comment_id" bigserial NOT NULL,
                                "user_id" bigserial NOT NULL
);

CREATE TABLE "post_like" (
                             "user_id" bigserial NOT NULL,
                             "post_id" bigserial NOT NULL,
                             "created_at" timestamptz DEFAULT (NOW())
);

CREATE TABLE "interest" (
                            "user_id" bigserial NOT NULL,
                            "topic_id" bigserial NOT NULL
);

CREATE INDEX ON "channel" ("owner_id");

CREATE INDEX ON "subscription_plan" ("channel_id");

CREATE UNIQUE INDEX ON "subscription" ("user_id", "plan_id");

CREATE INDEX ON "post" ("subscription_plan_id");

CREATE INDEX ON "post_topic" ("post_id");

CREATE INDEX ON "post_topic" ("topic_id");

CREATE INDEX ON "view" ("viewer_id");

CREATE INDEX ON "view" ("post_id");

CREATE INDEX ON "comment" ("post_id");

CREATE UNIQUE INDEX ON "comment_like" ("user_id", "comment_id");

CREATE UNIQUE INDEX ON "post_like" ("user_id", "post_id");

CREATE INDEX ON "interest" ("user_id");

CREATE UNIQUE INDEX ON "interest" ("user_id", "topic_id");

ALTER TABLE "user_credentials" ADD FOREIGN KEY ("user_id") REFERENCES "user_profile" ("id");

ALTER TABLE "channel" ADD FOREIGN KEY ("owner_id") REFERENCES "user_profile" ("id");

ALTER TABLE "subscription_plan" ADD FOREIGN KEY ("channel_id") REFERENCES "channel" ("id");

ALTER TABLE "subscription" ADD FOREIGN KEY ("user_id") REFERENCES "user_profile" ("id");

ALTER TABLE "subscription" ADD FOREIGN KEY ("plan_id") REFERENCES "subscription_plan" ("id");

ALTER TABLE "post" ADD FOREIGN KEY ("subscription_plan_id") REFERENCES "subscription_plan" ("id");

ALTER TABLE "post_topic" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "post_topic" ADD FOREIGN KEY ("topic_id") REFERENCES "topic" ("id");

ALTER TABLE "view" ADD FOREIGN KEY ("viewer_id") REFERENCES "user_profile" ("id");

ALTER TABLE "view" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("commenter_id") REFERENCES "user_profile" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "comment" ADD FOREIGN KEY ("parent_comment_id") REFERENCES "comment" ("id");

ALTER TABLE "comment_like" ADD FOREIGN KEY ("comment_id") REFERENCES "comment" ("id");

ALTER TABLE "comment_like" ADD FOREIGN KEY ("user_id") REFERENCES "user_profile" ("id");

ALTER TABLE "post_like" ADD FOREIGN KEY ("user_id") REFERENCES "user_profile" ("id");

ALTER TABLE "post_like" ADD FOREIGN KEY ("post_id") REFERENCES "post" ("id");

ALTER TABLE "interest" ADD FOREIGN KEY ("user_id") REFERENCES "user_profile" ("id");

ALTER TABLE "interest" ADD FOREIGN KEY ("topic_id") REFERENCES "topic" ("id");
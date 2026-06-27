CREATE SCHEMA todo_app;

CREATE TABLE todo_app.users (
    id           SERIAL                PRIMARY KEY,
    version      BIGINT       NOT NULL DEFAULT 1,

    full_name    VARCHAR(100) NOT NULL CHECK (char_length(full_name) BETWEEN 3 AND 100),
    phone_number VARCHAR(20)           CHECK (
        phone_number ~ '^\+[0-9]+$'
        AND
        char_length(phone_number) BETWEEN 10 AND 20
    ),

    is_deleted   BOOLEAN      NOT NULL DEFAULT FALSE,

    created_at   TIMESTAMPTZ  NOT NULL,
    updated_at   TIMESTAMPTZ  NOT NULL
);

CREATE TABLE todo_app.tasks (
    id           SERIAL                PRIMARY KEY,
    version      BIGINT       NOT NULL DEFAULT 1,

    title        VARCHAR(100) NOT NULL CHECK (char_length(title) BETWEEN 1 AND 100),
    description  VARCHAR(1000) CHECK (char_length(description) BETWEEN 1 AND 1000),

    is_completed BOOLEAN      NOT NULL DEFAULT FALSE,
    is_deleted   BOOLEAN               DEFAULT FALSE,

    created_by   INTEGER      NOT NULL REFERENCES todo_app.users(id),
    assign_to    INTEGER      NOT NULL REFERENCES todo_app.users(id),

    completed_at TIMESTAMPTZ,
    created_at   TIMESTAMPTZ  NOT NULL,
    updated_at   TIMESTAMPTZ  NOT NULL,

    CHECK (
        (is_completed=FALSE AND completed_at IS NULL)
        OR
        (is_completed=TRUE AND completed_at IS NOT NULL AND completed_at >= created_at)
    )
);

# The workflow demonstrated in the lesson is as follows:
1. Make the required changes to your schema file
2. Prepare the new migration script: `npx prisma migrate dev --create-only --name SOME-MEANINGFUL_NAME`
3. Fix the generated migration script to do what you want. Don't forget to migrate existing data!
4. Apply the changes to your database: `npx prisma migrate deploy`
5. Never change old migration scripts

## Prerequisities
run a local PostgreSQL server. Easiest is via Docker:
`docker run -p 5433:5432 -e POSTGRES_PASSWORD=topsecret postgres:alpine`

Put this in .env file: 
`DATABASE_URL="postgresql://postgres:topsecret@localhost:5433/postgres?schema=public"`

if you want to connect to the database to run queries:
`psql -U postgres -h localhost -p 5433`

Based on the official documentation https://www.prisma.io/docs/orm/prisma-migrate/getting-started

## Migration scripts in this project
### 1. Create initial migration for the Post table
Create the migration script: `npx prisma migrate dev --create-only --name init`

Apply the migration script: `npx prisma migrate deploy`

And add some records:
```
insert into "Post" (title, content) values ('First Post!', 'With some great content');
insert into "Post" (title, content) values ('Second Post!', 'Which is even better');`
select * from "Post";
```

### 2. add category field
```
npx prisma migrate dev --create-only --name add_category
npx prisma migrate dev
```
And update the data:
```
update "Post" set category='Weather';
```

### 3. change category -> topic
*Remember that you can't modify existing migrations!*
```
npx prisma migrate dev --create-only --name category_topic
```
and change the actual .sql script to 
```
ALTER TABLE "Post" rename COLUMN "categoryy" to "topic";
```

### 4. change structure - add categories table
```
npx prisma migrate dev --create-only --name topic_table
```
and change the actual .sql script to 
```
ALTER TABLE "Post" ADD COLUMN "topicId" INTEGER;

CREATE TABLE "Topic" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,

    CONSTRAINT "Topic_pkey" PRIMARY KEY ("id")
);

INSERT INTO "Topic" (title) SELECT DISTINCT "topic" FROM "Post";
UPDATE "Post" SET "topicId" = (SELECT id FROM "Topic" WHERE "title" = "topic");

ALTER TABLE "Post" DROP COLUMN "topic";
```

## Bonus: database migrations that have been applied are stored in this table 
```
select * from _prisma_migrations ;
```

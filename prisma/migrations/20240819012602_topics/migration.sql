/*
  Warnings:

  - You are about to drop the column `topic` on the `Post` table. All the data in the column will be lost.
  - Added the required column `topicId` to the `Post` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable

ALTER TABLE "Post" ADD COLUMN "topicId" INTEGER;

CREATE TABLE "Topic" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,

    CONSTRAINT "Topic_pkey" PRIMARY KEY ("id")
);


INSERT INTO "Topic" (title) SELECT DISTINCT "topic" FROM "Post";
UPDATE "Post" SET "topicId" = (SELECT id FROM "Topic" WHERE "title" = "topic");

ALTER TABLE "Post" DROP COLUMN "topic";


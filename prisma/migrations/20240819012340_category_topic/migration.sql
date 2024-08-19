/*
  Warnings:

  - You are about to drop the column `categoryy` on the `Post` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Post" rename COLUMN "categoryy" to "topic";

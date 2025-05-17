-- CreateEnum
CREATE TYPE "game_status" AS ENUM ('inprogress', 'completed');

-- CreateEnum
CREATE TYPE "answering_team" AS ENUM ('team1', 'team2');

-- CreateTable
CREATE TABLE "games" (
    "id" UUID NOT NULL,
    "host_id" TEXT NOT NULL,
    "team1_name" TEXT NOT NULL,
    "team1_score" INTEGER NOT NULL DEFAULT 0,
    "team2_name" TEXT NOT NULL,
    "team2_score" INTEGER NOT NULL DEFAULT 0,
    "status" "game_status" NOT NULL DEFAULT 'inprogress',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "games_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "image_url" TEXT,
    "description" TEXT,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_categories" (
    "id" UUID NOT NULL,
    "game_id" UUID NOT NULL,
    "category_id" UUID NOT NULL,

    CONSTRAINT "game_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "questions" (
    "id" UUID NOT NULL,
    "category_id" UUID NOT NULL,
    "difficulty" INTEGER NOT NULL,
    "question_text" TEXT NOT NULL,
    "question_media_meta" JSONB,
    "answer_text" TEXT NOT NULL,
    "answer_media_meta" JSONB,

    CONSTRAINT "questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "game_questions" (
    "id" UUID NOT NULL,
    "game_category_id" UUID NOT NULL,
    "question_id" UUID NOT NULL,
    "picked" BOOLEAN NOT NULL DEFAULT false,
    "answered" BOOLEAN NOT NULL DEFAULT false,
    "answering_team" "answering_team",
    "answered_at" TIMESTAMP(3),

    CONSTRAINT "game_questions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "categories_name_key" ON "categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "game_categories_game_id_category_id_key" ON "game_categories"("game_id", "category_id");

-- CreateIndex
CREATE UNIQUE INDEX "game_questions_game_category_id_question_id_key" ON "game_questions"("game_category_id", "question_id");

-- AddForeignKey
ALTER TABLE "game_categories" ADD CONSTRAINT "game_categories_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "games"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_categories" ADD CONSTRAINT "game_categories_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "questions" ADD CONSTRAINT "questions_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_questions" ADD CONSTRAINT "game_questions_game_category_id_fkey" FOREIGN KEY ("game_category_id") REFERENCES "game_categories"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "game_questions" ADD CONSTRAINT "game_questions_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "questions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

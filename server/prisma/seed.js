import { PrismaClient } from "@prisma/client";

const prisma = new PrismaClient();

// 1) Define your categories
const categories = [
    {
        name: "Flags",
        imageUrl: "https://via.placeholder.com/150",
        description: "Placeholder category image",
    },
    {
        name: "Maps",
        imageUrl: "https://via.placeholder.com/150",
        description: "Placeholder category image",
    },
    {
        name: "Harry Potter",
        imageUrl: "https://via.placeholder.com/150",
        description: "Placeholder category image",
    },
    {
        name: "Star Wars",
        imageUrl: "https://via.placeholder.com/150",
        description: "Placeholder category image",
    },
    {
        name: "General",
        imageUrl: "https://via.placeholder.com/150",
        description: "Placeholder category image",
    },
    {
        name: "Music",
        imageUrl: "https://via.placeholder.com/150",
        description: "Placeholder category image",
    },
];

// 2) Programmatically generate 6 questions per category
const difficulties = [200, 400, 600];

const questions = [];

for (const cat of categories) {
    for (const diff of difficulties) {
        for (let i = 1; i <= 2; i++) {
            questions.push({
                categoryName: cat.name,
                difficulty: diff,
                questionText: `Placeholder question ${i} for ${cat.name} at ${diff}`,
                questionMediaMeta: {
                    url: "https://via.placeholder.com/300",
                    type: "image",
                },
                answerText: `Placeholder answer ${i} for ${cat.name} at ${diff}`,
                answerMediaMeta: {
                    url: "https://via.placeholder.com/300",
                    type: "image",
                },
            });
        }
    }
}

async function main() {
    // Upsert categories so we can reference their IDs
    for (const cat of categories) {
        await prisma.category.upsert({
            where: { name: cat.name },
            update: {},
            create: {
                name: cat.name,
                imageUrl: cat.imageUrl,
                description: cat.description,
            },
        });
    }

    // Fetch all categories to build a name→id map
    const allCats = await prisma.category.findMany();
    const catMap = {};
    allCats.forEach((c) => {
        catMap[c.name] = c.id;
    });

    // Insert questions
    for (const q of questions) {
        await prisma.question.create({
            data: {
                categoryId: catMap[q.categoryName],
                difficulty: q.difficulty,
                questionText: q.questionText,
                questionMediaMeta: q.questionMediaMeta,
                answerText: q.answerText,
                answerMediaMeta: q.answerMediaMeta,
            },
        });
    }

    console.log(
        `Seeded ${categories.length} categories and ${questions.length} questions.`
    );
}

main()
    .catch((e) => {
        console.error(e);
        process.exit(1);
    })
    .finally(async () => {
        await prisma.$disconnect();
    });

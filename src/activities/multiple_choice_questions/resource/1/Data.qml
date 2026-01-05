/* GCompris - Data.qml
 *
 * SPDX-FileCopyrightText: 2024 Johnny Jazeix <jazeix@gmail.com>
 * SPDX-License-Identifier: GPL-3.0-or-later
 */
import core 1.0

// This is only a test dataset, not used in the application to show how it works.
Data {
    objective: "Find the correct answer."
    difficulty: 1
    data: [
        {
            "shuffle": true,
            "subLevels": [
            {
                "shuffleAnswers": true,
                "question": "What is the first number?",
                "answers": ["1", "2", "cat"],
                "correctAnswers": ["1"],
                "correctAnswerText": "Yes, 1 is the first number",
                "wrongAnswerText": "The first number is the one that starts",
                "mode": "oneAnswer"
            },
            {
                "shuffleAnswers": false,
                "question": "What is a color?",
                "answers": ["yellow", "12", "cat"],
                "correctAnswers": ["yellow"],
                "correctAnswerText": "Yellow is a color.",
                "wrongAnswerText": "There is a color, an animal and a number in the answers, select the correct one",
                "mode": "oneAnswer"
            }
            ]
        },
        {
            "shuffle": false,
            "subLevels": [
            {
                "shuffleAnswers": true,
                "question": "What are the first two numbers?",
                "answers": ["1", "2", "cat"],
                "correctAnswers": ["1", "2"],
                "correctAnswerText": "Yes, there are two correct answers!",
                "wrongAnswerText": "Cat is not an answer",
                "mode": "multipleAnswers"
            },
            {
                "shuffleAnswers": true,
                "question": "What are animals?",
                "answers": ["1", "2", "cat"],
                "correctAnswers": ["cat"],
                "correctAnswerText": "Yes, cat is an animal!",
                "wrongAnswerText": "Numbers are not animals",
                "mode": "multipleAnswers"
            }
            ]
        },
        {
            "shuffle": false,
            "subLevels": [
            {
                "shuffleAnswers": false,
                "question": "Answers always in order, select the first one",
                "answers": ["1", "2", "cat"],
                "correctAnswers": ["1"],
                "mode": "oneAnswer"
            }
            ]
        }
    ]
}

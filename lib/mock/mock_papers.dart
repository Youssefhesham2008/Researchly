import '../models/paper_model.dart';

/// أبحاث موك (ثابتة) fallback في حالة الـ API مش شغال
final List<Paper> mockPapers = [
  Paper(
    id: "mock1",
    title: "Advances in Artificial Intelligence",
    authors: ["John Doe", "Jane Smith"],
    summary:
    "This paper explores the latest advances in Artificial Intelligence, including deep learning and reinforcement learning techniques.",
    publishedDate: DateTime(2023, 5, 10),
    categories: ["cs.AI"],
    paperUrl: "https://arxiv.org/abs/2305.00001",
    imageUrl:
    "https://img.freepik.com/free-photo/ai-robot-face-futuristic-technology-background_53876-129770.jpg",
  ),
  Paper(
    id: "mock2",
    title: "Quantum Mechanics in Modern Physics",
    authors: ["Albert Einstein", "Niels Bohr"],
    summary:
    "An overview of quantum mechanics principles and their application in modern physics research.",
    publishedDate: DateTime(2023, 6, 15),
    categories: ["physics.gen-ph"],
    paperUrl: "https://arxiv.org/abs/2306.00002",
    imageUrl:
    "https://img.freepik.com/free-vector/quantum-physics-illustration-background_23-2149262368.jpg",
  ),
  Paper(
    id: "mock3",
    title: "Mathematical Models for Complex Systems",
    authors: ["Ada Lovelace", "Alan Turing"],
    summary:
    "Discusses mathematical models used to simulate and understand complex dynamic systems.",
    publishedDate: DateTime(2023, 7, 20),
    categories: ["math"],
    paperUrl: "https://arxiv.org/abs/2307.00003",
    imageUrl:
    "https://img.freepik.com/free-vector/mathematics-doodle-background_23-2148158092.jpg",
  ),
  Paper(
    id: "mock4",
    title: "Advances in Biomedical Research",
    authors: ["Rosalind Franklin", "James Watson"],
    summary:
    "Exploring cutting-edge biomedical research and its impact on modern medicine.",
    publishedDate: DateTime(2023, 8, 12),
    categories: ["q-bio.BM"],
    paperUrl: "https://arxiv.org/abs/2308.00004",
    imageUrl:
    "https://img.freepik.com/free-photo/medical-research-background-with-3d-molecules_1048-12751.jpg",
  ),
  Paper(
    id: "mock5",
    title: "Discoveries in Molecular Biology",
    authors: ["Francis Crick", "Barbara McClintock"],
    summary:
    "This study highlights recent discoveries in the field of molecular biology, focusing on genetic regulation.",
    publishedDate: DateTime(2023, 9, 5),
    categories: ["q-bio"],
    paperUrl: "https://arxiv.org/abs/2309.00005",
    imageUrl:
    "https://img.freepik.com/free-photo/biology-molecular-structure-background_23-2148709381.jpg",
  ),
];

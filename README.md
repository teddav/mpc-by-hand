# 🧮 MPC by Hand

> A hands-on exploration of secure computation and zero-knowledge.

If you’re new to MPC (Multi-Party Computation), there’s a lot to unpack.
This repo walks through the fundamental building blocks. Step by step, from the ground up.

We start simple, and quickly get into some really exciting things:

- 🧩 Oblivious Transfer (OT): how two parties exchange secrets without revealing them
- ⚙️ Oblivious Linear Evaluation (OLE): turning OT into arithmetic form
- 🧠 Vector OLE (VOLE): scaling OLE efficiently for real MPC protocols
- ⚡ QuickSilver: combining MPC and ZK to build a fast, practical zero-knowledge proof system

Each concept comes with annotated SageMath code and explanations you can read alongside, so you can actually see the math in action.

## 📚 Learn the Theory

This repository is meant to be read alongside the articles.  
They explain the math, ideas, and cryptographic context behind each primitive.

👉 Read the full series here:
[https://research.electisec.com/mpc](https://research.electisec.com/mpc)

Each article walks through one layer of the stack, showing how these concepts connect to form efficient MPC and ZK protocols.

## Run the code
You can run everything directly in your browser: [Sagecell](https://sagecell.sagemath.org)

Or locally using Docker:
```bash
docker run -it --rm sagemath/sagemath
```
See more setup details here: [https://teddav.github.io/blog/sagemath](https://teddav.github.io/blog/sagemath)
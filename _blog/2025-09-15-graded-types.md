---
layout: blog-post
title: "Graded Types for Resource-Aware Programming"
date: 2025-09-15
categories: [research, type-systems, programming-languages]
excerpt: "An overview of graded modal types and how they capture fine-grained program properties for resource tracking and program verification."
---

Graded modal types provide a powerful framework for capturing fine-grained information about programs at the type level. This post explores some of the key ideas.

## What Are Graded Types?

Graded types extend the Curry-Howard correspondence by incorporating graded modalities from modal logic. These grades can capture various program properties:

- **Resource usage**: How many times a value is used
- **Coeffects**: What resources are required for computation
- **Effects**: What computational effects occur

## Applications

Some practical applications of graded types include:

1. **Memory safety**: Tracking linear and affine resources
2. **Security**: Information flow control
3. **Performance**: Optimizing based on usage patterns
4. **Distributed systems**: Session types with graded protocols

## The Granule Project

Our [Granule project](https://granule-project.github.io/) is exploring these ideas through a practical programming language implementation.

Stay tuned for more posts on specific aspects of graded type systems!

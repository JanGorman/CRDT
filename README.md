# CRDT

[![Build Status](https://travis-ci.org/JanGorman/CRDT.svg?branch=master)](https://travis-ci.org/JanGorman/CRDT)
[![codecov](https://codecov.io/gh/JanGorman/CRDT/branch/master/graph/badge.svg)](https://codecov.io/gh/JanGorman/CRDT)
[![SPM](https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat)](https://swift.org/package-manager)

A toy implementation of [conflict-free replicated data types](https://en.wikipedia.org/wiki/Conflict-free_replicated_data_type) in Swift.

## Usage

Add the dependency to your `Package.swift` file. The implementation includes:

* Grow-only Set
* Last-Write-Wins-Element-Set
* Observed-Remove-Set
* Two-Phase-Set

## Licence

CRDT is released under the MIT license. See LICENSE for details.
## composite

[![Build status](https://github.com/composite-hs/composite-base/actions/workflows/workflow.yml/badge.svg)](https://github.com/composite-hs/composite-base/actions/workflows/workflow.yml)

Composite is a group of libraries focusing on practical uses of composite records, in particular [Vinyl](https://github.com/VinylRecords/Vinyl/), such as querying records from a database and converting them to JSON. These libraries are based on the excellent [Frames](https://github.com/acowley/Frames) style use of Vinyl records, though composite implements its own derived from Frames to make for a smaller dependency graph, as Frames is a full CSV parsing/printing and data manipulation library.

Downstream projects have moved to https://github.com/composite-hs/composite.

### `composite-base`

Definitions shared by the other composite libraries or generally useful when using Vinyl records. Includes some Template Haskell splices to generate various optics for records, as well as a specialization of `MonadReader` which works on a context record, providing general environment for a computation.

## Maturity

As of writing, we use these libraries in all our Haskell projects internally and have had no major issues. There are spots using either composite or vinyl where the compiler error messages could use improvement. There are certain use cases that can cause the simplifier to crash, though we have not observed any runtime errors as yet. They have not been proven out for performance at larger scale. We'd appreciate any fixes, improvements, or experience reports.

## Contributing

Contributions and feedback welcome! File an issue or make a PR.

ObjectPacker
============

Move data from objects to arrays and back. Useful in serialization pipeline.

The way data is stored on disk is fairly similar to an array.
It's a bunch of data layed out in a line.
So, it's easy to go from and array to any serialization format.

This library focuses on converting from objects to arrays, so you can delay picking a serialization format. Or, even switch between formats (YAML, CSV, Array#pack, etc) as much as you like.

It's much easier when you separate object-to-data translation from memory-to-disk transfer

## Usage
ObjectPacker provides a zero-argument executable which expects a configuration file in the working directory called object-packer.config.yml (similar to Rake and make).  This config file is a YAML document that specifies the source and output directories (see bin/ for an example config)

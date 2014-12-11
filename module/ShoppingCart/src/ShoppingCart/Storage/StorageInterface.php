<?php
namespace ShoppingCart\Storage;


interface StorageInterface {

    public function isEmpty();

    public function read();

    public function write($contents);

    public function clear();
} 
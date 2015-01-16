<?php
namespace ShoppingCart\Model;

use ShoppingCart\Storage;

class ShoppingCart
{
    /**
     * @type array
     */
    public $items = [];

    /**
     * @type int
     */
    protected $total = 0;

    /**
     * @type null
     */
    protected $storage = NULL;

    /**
     * @param Storage\StorageInterface $storage
     */
    public function __construct( Storage\StorageInterface $storage = NULL )
    {
        if (NULL !== $storage) {
            $this->setStorage( $storage );
        }
        $storage = $this->getStorage();
        if (!$storage->isEmpty()) {
            $this->items = $storage->read();
        }
    }

    /**
     * @param Storage\StorageInterface $storage
     *
     * @return $this
     */
    public function setStorage( Storage\StorageInterface $storage )
    {
        $this->storage = $storage;
        return $this;
    }

    /**
     * @return StorageInterface
     */
    private function getStorage()
    {
        if (NULL === $this->storage) {
            $this->setStorage( new Storage\Session() );
        }
        return $this->storage;
    }

    /**
     * @param Item $item
     * @param      $qty
     *
     * @return bool|Item
     */
    public function addItem( Item $item )
    {
        $this->items[$item->hash] = $item;
        $this->persist();
        return $item;
    }

    /**
     * @param $item
     */
    public function removeItem( $item )
    {
        if (is_string( $item )) {
            unset($this->items[$item]);
        }
        if ($item instanceof Item) {
            unset($this->items[$item->hash]);
        }
        $this->persist();
    }

    /**
     * @param Item $item
     *
     * @return bool
     */
    public function itemExists( $item )
    {
        if (is_string( $item )) {
            return isset($this->items[$item]);
        }
        if ($item instanceof Item) {
            return isset($this->items[$item->hash]);
        }
    }

    /**
     * @return bool
     */
    public function clear()
    {
        $this->getStorage()->clear();
        return TRUE;
    }

    private function persist()
    {
        $this->getStorage()
             ->clear();

        $this->getStorage()
             ->write( $this->items );
    }
}
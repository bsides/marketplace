<?php
namespace ShoppingCart\Model;

class Item
{
    /**
     * @type string
     */
    public $hash;

    /**
     * @type string
     */
    public $features;

    /**
     * @type array
     */
    public $ads;

    /**
     * @type array
     */
    public $price;


    public function __construct(array $options = null)
    {
        if (is_array($options)) {
            $this->setOptions($options);
        }
    }

    public function setOptions(array $options)
    {
        $vars = get_object_vars($this);
        array_filter($options, function(&$item) {
            if (!is_array($item)) {
                $item = trim($item);
            }
        });

        foreach ($options as $var => $value) {
            if (in_array($var, array_keys($vars))) {
                $this->{$var} = $value;
            }
        }
        return $this;
    }
}

<?php
namespace ShoppingCart\Model;

class Ad
{
    /**
     * @type string
     */
    public $comment;

    /**
     * @type string
     */
    public $date;

    /**
     * @type decimal
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
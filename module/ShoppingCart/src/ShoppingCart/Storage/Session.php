<?php
namespace ShoppingCart\Storage;

use Zend\Session\Container as SessionContainer;
use Zend\Session\ManagerInterface as SessionManager;

class Session implements StorageInterface
{

    const NAMESPACE_DEFAULT = 'ShoppingCart\Storage';

    /**
     * Default session object member name
     */
    const MEMBER_DEFAULT = 'storage';

    /**
     * Object to proxy $_SESSION storage
     *
     * @var SessionContainer
     */
    protected $session;

    /**
     * Session namespace
     *
     * @var mixed
     */
    protected $namespace = self::NAMESPACE_DEFAULT;

    /**
     * Session object member
     *
     * @var mixed
     */
    protected $member = self::MEMBER_DEFAULT;

    /**
     * Sets session storage options and initializes session namespace object
     *
     * @param  mixed $namespace
     * @param  mixed $member
     * @param  SessionManager $manager
     */
    public function __construct($namespace = null, $member = null, SessionManager $manager = null)
    {
        if ($namespace !== null) {
            $this->namespace = $namespace;
        }
        if ($member !== null) {
            $this->member = $member;
        }
        $this->session   = new SessionContainer($this->namespace, $manager);
    }

    /**
     * Returns the session namespace
     *
     * @return string
     */
    public function getNamespace()
    {
        return $this->namespace;
    }

    /**
     * Returns the name of the session object member
     *
     * @return string
     */
    public function getMember()
    {
        return $this->member;
    }

    /**
     * Defined by Zend\Authentication\Storage\StorageInterface
     *
     * @return bool
     */
    public function isEmpty()
    {
        return !isset($this->session->{$this->member});
    }

    /**
     * Defined by Zend\Authentication\Storage\StorageInterface
     *
     * @return mixed
     */
    public function read()
    {
        return unserialize($this->session->{$this->member});
    }

    /**
     * Defined by Zend\Authentication\Storage\StorageInterface
     *
     * @param  mixed $contents
     * @return void
     */
    public function write($contents)
    {
        $this->session->{$this->member} = serialize($contents);
    }

    /**
     * Defined by Zend\Authentication\Storage\StorageInterface
     *
     * @return void
     */
    public function clear()
    {
        unset($this->session->{$this->member});
    }
}

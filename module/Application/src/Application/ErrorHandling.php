<?php
/**
 * Created by PhpStorm.
 * User: rpsouza
 * Date: 26/01/15
 * Time: 15:48
 */

namespace Application;


use Exception;

class ErrorHandling
{
    protected $logger;

    function __construct( $logger )
    {
        $this->logger = $logger;
    }

    function logException( Exception $e )
    {
        $trace = $e->getTraceAsString();
        $i = 1;
        do {
            $messages[] = $i++ . ": " . $e->getMessage();
        } while ($e = $e->getPrevious());

        $log = "Exception:n" . implode( "n", $messages );
        $log .= "nTrace:n" . $trace;

        $this->logger->err( $log );
    }
}

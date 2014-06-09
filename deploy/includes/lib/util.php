<?php
function get_base_href()
{
    $href =  !empty( $_SERVER[ 'HTTPS' ] ) && $_SERVER[ 'HTTPS' ] === 'on' ? 'https://' : 'http://';
    $href .= $_SERVER[ 'HTTP_HOST' ] . htmlentities( dirname( $_SERVER[ 'PHP_SELF' ] ) );

    //add trailing slash if necessary
    if ( substr( $href, -1 ) != '/' )
    {
        $href .= '/';
    }

    return $href;
}


//
// detect scrapers from social networks
//
function is_scraper( $str ){
    if (strpos( $str, 'facebookexternalhit') !== false) {
        return 'facebook';
    }
    if (strpos( $str, 'LinkedInBot') !== false){
        return 'linkedin';
    }
    if (strpos( $str, 'developers.google.com') !== false) {
        return 'google';
    }
    return false;
}

#EOF
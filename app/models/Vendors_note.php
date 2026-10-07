<?php
use Phalcon\Mvc\Model;
class Vendors_note extends Model
{
	public $id;
    public $id_vendor;
    public $note;
    public $off_status;
    public $postdate;
    public $timestamp;
    public $user_id;
}
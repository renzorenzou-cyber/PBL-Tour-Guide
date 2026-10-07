<?php
use Phalcon\Mvc\Model;
class Vendors_attributes extends Model
{
	public $id;
    public $id_vendor;
    public $attribute_name;
    public $attribute_value;
    public $attribute_group;
    public $created_at;
    public $created_by;
}
<?php
use Phalcon\Mvc\Model;
class Userspermissions_role extends Model
{
	public $id;
	public $name;
	public $description;
	public $type;
	public $created_by;
	public $updated_by;
}
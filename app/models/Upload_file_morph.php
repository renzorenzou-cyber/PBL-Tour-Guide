<?php
use Phalcon\Mvc\Model;
class upload_file_morph extends Model
{
	public $id;
	public $upload_file_id;
	public $related_id;
	public $related_type;
	public $field;
	public $order;
}
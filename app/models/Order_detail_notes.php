<?php
use Phalcon\Mvc\Model;
class Order_detail_notes extends Model
{
	public $id;
    public $note_type;
	public $note;
	public $note_meta;
	public $user_id;
	public $order_detail_id;
    public $published_at;
    public $created_by;
    public $created_at;
    public $updated_at;

}
<?php
use Phalcon\Mvc\Model;
class User_logs extends Model
{
	public $id;
	public $user_id;
	public $table_name;
    public $data_id;
    public $activity;
    public $published_at;
    public $created_by;
    public $updated_by;
    public $created_at;
    public $updated_at;
}
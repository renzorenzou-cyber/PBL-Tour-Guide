<?php
use Phalcon\Mvc\Model;
class Account_jurnals extends Model
{
	public $id;
    public $account_number;
    public $account_name;
    public $account_desc;
    public $account_category;
    public $account_parent;
    public $user_id;
    public $published_at;
    public $created_by;
    public $updated_by;
    public $created_at;
    public $updated_at;
}
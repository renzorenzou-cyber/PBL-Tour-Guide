<?php
use Phalcon\Mvc\Model;
class Userspermissions_user extends Model
{
	public $id;
	public $username;
	public $email;
	public $provider;
	public $password;
	public $resetPasswordToken;
	public $confirmationToken;
	public $confirmed;
	public $blocked;
	public $role;
	public $parent;
	public $company;
	public $created_by;
	public $updated_by;
	public $created_at;
	public $updated_at;
	public $taxpercent;
	public $phone;
	public $name;
	public $user_code;
	public $white_label;
	public $unique_code;
	public $referall_code;
	public $avatar;
}

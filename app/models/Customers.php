<?php
use Phalcon\Mvc\Model;
class Customers extends Model
{
	public $id;
    public $name;
    public $email;
    public $password;
    public $phone;
    public $country;
    public $date_of_birth;
    public $gender;
    public $address;
    public $avatar;
    public $created_by;
    public $updated_by;
    public $activation_created_at;
    public $created_at;
    public $updated_at;
}
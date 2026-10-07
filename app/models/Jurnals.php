<?php
use Phalcon\Mvc\Model;
class Jurnals extends Model
{
	public $id;
	public $order_detail_id;
	public $order_date;
	public $parent_id;
    public $booking_reference;
	public $keterangan;
	public $tipe_jurnal;
	public $total;
	public $jurnal_account;
	public $id_supplier;
	public $supplier_name;
	public $post_date;
    public $paid_status;
}
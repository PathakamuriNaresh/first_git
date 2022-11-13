//////Driver-sequence handshaking mechanism/////////////
//2nd time modified 


//test_class run_phase:start() method

virtual task run_phase(uvm_phase phase)
super.run_phase(phase);
 
seq_h=base_sequence::type_id::create("seq_h");

    phase.raise_objection(this);
	seq_h.start(env_h.agnt.seqr_h);
    phase.drop_objection(this);

endtask



//sequence:body() method

virtual task body();
req=seq_item::type_id::create("req");

   repeat(5) begin

	start_item(req);
	void`(req.randomize());
	`uvm_info(get_type_name(),"Data send to Druver",UVM_NONE)
	req.print();
	finish_item(req);

end
endtask




//DRiver:run_phase():

virtual task run_phase(uvm_phase phase);
super.run_phase(phase);

forever begin

	seq_item_port.get_next_item(req);
	drive_item(req);
	seq_item_port.item_done();

end
endtask


//user defined drive() task:

virtual task drive_item(seq_item xtn);
@(posedge vif.clk);

vif.drv_cb.wr_en <= xtn.wr_en;
vif.drv_cb.rd_en <= xtn.rd_en;
vif.drv_cb.data_in <= xtn.data_in;

`uvm_info(get_type_name(),"send Data to DUT", UVM_NONE)
xtn.print();

repeat(2) @(vif.drv_cb);
endtask






var TicketForm = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection,
            event_slug: this.props.event_slug,
            onAddedNewItem: this.props.onAddedNewItem


        }
    },
    setItemDate: function(dateText) {
        ticketObj = this.state.current_selection;
        ticketObj["stop_date"] = dateText;
        this.setState({current_selection: ticketObj})
    },
    componentWillReceiveProps: function(nextProps) {
      nextProps.current_selection.stop_date = nextProps.current_selection.stop_date.indexOf('/') > -1 ? nextProps.current_selection.stop_date :  moment(nextProps.current_selection.stop_date).format('MM/DD/YYYY');
        
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },

    handleValidation: function(e) {
      e.preventDefault();

    },

    componentDidMount: function() {


        var that = this;
        //format specific 
        this.state.current_selection.stop_date = this.state.current_selection.stop_date.indexOf('/') > -1 ? this.state.current_selection.stop_date : moment(this.state.current_selection.stop_date).format('MM/DD/YYYY');
        this.setState({current_selection: this.state.current_selection})
        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {

            that.setItemDate(dateText);
            $('.date').focusout();
          },
          'format': 'MM/DD/YYYY',
          'autoclose': true
        });


   var validator5 = $(".ticket-form").validate({
    submitHandler: function() { that.handleUpdate() },
    rules: {
      "title": {
        required: true
      },
      "price": {
        required: true
      },
      "ticket_limit": {
        required: true
      },
      "buy_limit": {
        required: true
      },
      "stop_date": {
        required: true
      },
    }, messages : {
      "title": 'Please enter a ticket name.',
      "price": 'Please enter a ticket price.',
      "ticket_limit": 'Please enter a ticket limit.',
      "buy_limit": 'Please enter a buy limit.',
      "stop_date": 'Please enter an end date.'

    }
  });


   
    },
    handleUpdate: function() {
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");
      
        var method, uri, save_message;
        if (this.state.current_selection.id == null) {
            method = 'POST'
            uri = this.props.event_slug + '/tickets'
            save_message = 'Ticket has been created'

        } else {
            method = 'PUT'
            uri = '/tickets/' + this.state.current_selection.id
            save_message = 'Ticket has been updated'
        }

        var that = this;

        $.ajax({
            method: method,
            url: uri,
            data: {"ticket" : {
                     "title" : this.state.current_selection.title, 
                      "description" : this.state.current_selection.description, 
                      "price" : this.state.current_selection.price, 
                      "ticket_limit" : this.state.current_selection.ticket_limit, 
                      "buy_limit" : this.state.current_selection.buy_limit, 
                      "stop_date" : this.state.current_selection.stop_date,
                      "is_active" : this.state.current_selection.is_active
            }},
            dataType: 'JSON',
            success: function(resp) {
               that.state.current_selection = resp;
               //that.state.current_selection.stop_date =  moment(resp.stop_date).format('MM/DD/YYYY');
               
               that.props.onAddedNewItem(that.state.current_selection, (method == 'POST'));
               that.props.onUpdateMessage(save_message);
               
            }.bind(this)
        });

        

    },
    handleCancel: function(e) {
        e.preventDefault();
        //this.setState({current_selection: null})
         this.props.onResetCurrentSelection();
    },

    handleDelete: function(e){
        e.preventDefault();
        var that = this;


        var itemID = this.state.current_selection.id;

        $.ajax({
            method: 'POST',
            url: '/remove-ticket',
            data: {id: this.state.current_selection.id },
            dataType: 'JSON',
            success: function(resp) {
                that.props.onUpdateMessage(resp.message);
                if(resp.status == 'success') {
                    that.props.onRemovedNewItem(itemID);
                }

                //this.props.handleDeleteEvent(this.props.event)
            }.bind(this)
        });



    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        ticketObj = this.state.current_selection;
        ticketObj[name] = e.target.value;
        this.setState({current_selection: ticketObj});
    },


    render: function() {

        var deleteButton = '' 
        if(this.state.current_selection.id != undefined) {
          deleteButton = <a onClick={this.handleDelete} className="link-delete"><i className="fa fa-trash"></i> Delete ticket</a>
        }

        return (
                <div>
                <div className="page-header">
                    <h1>{this.props.current_selection.title}</h1>
                </div>
                    <form className="ticket-form" onSubmit={this.handleValidate}>
                        <div className="input-group">
                            <label> Ticket Name</label>
                            <input name="title" type="text" value={this.state.current_selection.title} onChange={this.handleChange} />
                        </div>
                        <div className="input-group">
                            <label> Ticket Active</label>
                            <select name="is_active"  value={this.state.current_selection.is_active} onChange={this.handleChange} >
                                <option value="true">Active</option>
                                <option value="false">Inactive</option>
                              </select>
                        </div>
                        <div className="input-group">
                            <label>Price</label>
                            <input name="price" type="text" value={this.state.current_selection.price == undefined ? 0 : this.state.current_selection.price} onChange={this.handleChange} disabled={!this.props.advance_tickets}  />
                        </div>
                        <div className="input-group">
                            <label>Quantity Available</label>
                            <input name="ticket_limit" type="text" value={this.state.current_selection.ticket_limit} onChange={this.handleChange}  />
                        </div>
                        <div className="input-group">
                            <label>Buy Limit</label>
                            <input name="buy_limit" type="text"  value={this.state.current_selection.buy_limit} onChange={this.handleChange}/>
                        </div>
                        <div className="input-group">
                            <label>Description</label>
                            <input name="description" type="text"  value={this.state.current_selection.description} onChange={this.handleChange} />
                        </div>
                        <div className="input-group" id="datepairExample">
                            <label>Registration closes on</label>
                            <input name="stop_date" className="date" type="text"  value={this.state.current_selection.stop_date} onChange={this.handleChange}/>
                        </div>
                        <div className="input-group">
                            <button type="submit" className="btn btn-primary">{this.state.current_selection.id == undefined ? 'Save' : 'Update' }</button> <button onClick={this.handleCancel} className="btn btn-primary btn-gray">Cancel</button> {deleteButton}
                        </div>
                    </form>
                </div>


        )
    }

});





       
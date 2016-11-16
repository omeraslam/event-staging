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

   
    },
    handleUpdate: function(e) {
        e.preventDefault();
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");
        var method, uri;
        if (this.state.current_selection.id == null) {
            method = 'POST'
            uri = this.props.event_slug + '/tickets'
        } else {
            method = 'PUT'
            uri = '/tickets/' + this.state.current_selection.id
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
               
               that.props.onAddedNewItem(that.state.current_selection);
               that.props.onUpdateMessage('Ticket has been updated');
               
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

        alert(JSON.stringify(this.state.current_selection));

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
          deleteButton = <button onClick={this.handleDelete} className="btn btn-primary">Delete</button>
        }

        return (
                <div>
                <h1>{this.props.current_selection.title}</h1>

                    <form>
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
                            <button onClick={this.handleUpdate} className="btn btn-primary">{this.state.current_selection.id == undefined ? 'Save' : 'Update' }</button> <button onClick={this.handleCancel} className="btn btn-primary">Cancel</button> {deleteButton}
                        </div>
                    </form>
                </div>


        )
    }

});





       
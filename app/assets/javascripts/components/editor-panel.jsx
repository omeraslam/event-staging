var EditorPanel = React.createClass({
    getInitialState: function() {
        return { current_selection: this.props.current_selection}
    },
    // getDefaultProps: function() {
    //     return { current_selection: null}
    // },

    componentDidMount: function() {

        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {
            $('.date').focusout();
          },
          'format': 'm/d/yyyy',
          'autoclose': true
        });

        $('#datepairExample').datepair({
          parseDate: function(input) {
            return $(input).datepicker('getDate');
          },
          updateDate: function(input, dateObj) {
            alert(input);
            return $(input).datepicker('setDate', dateObj);
          }
        });


   
    },

    // componentWillReceiveProps: function(nextProps) {
    //     //alert('current_item: '+ current_selection);
    
    //   this.setState({
    //     current_selection: nextProps.current_selection
    //   });
    // },
    // 
    handleUpdate: function(e) {
        alert('handle update');
        e.preventDefault();
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");


        $.ajax({
            method: 'PUT',
            url: '/tickets/' + this.props.current_selection.id,
            data: {"ticket" : {
                     "title" : this.props.current_selection.title, 
                      "description" : this.props.current_selection.description, 
                      "price" : this.props.current_selection.price, 
                      "ticket_limit" : this.props.current_selection.ticket_limit, 
                      "buy_limit" : this.props.current_selection.buy_limit, 
                      "stop_date" : this.props.current_selection.stop_date
            }},
            dataType: 'JSON',
            success: function() {
               //alert('success');
               // this.props.handleDeleteEvent(this.props.event)
               
            }.bind(this)
        });
    },

    handleChange: function(e) {
        ticketObj = this.props.current_selection;
        ticketObj["stop_date"] = e.target.value;

        console.log(ticketObj);
        this.setState({current_selection: ticketObj})
    },
    render: function() {
        return (
            <div className="editor-panel">
            
                <h1>{this.props.current_selection.title}</h1>

                <form>
                    <div className="input-group">
                        <label> Ticket Name</label>
                        <input type="text" defaultValue={this.props.current_selection.title} />
                    </div>
                    <div className="input-group">
                        <label> Ticket Active</label>
                        <input type="text" defaultValue={this.props.current_selection.active} />
                    </div>
                    <div className="input-group">
                        <label>Quantity Available</label>
                        <input type="text" defaultValue={this.props.current_selection.ticket_limit} />
                    </div>
                    <div className="input-group">
                        <label>Buy Limit</label>
                        <input type="text" defaultValue={this.props.current_selection.buy_limit} />
                    </div>
                    <div className="input-group">
                        <label>Description</label>
                        <input type="text" defaultValue={this.props.current_selection.description} />
                    </div>
                    <div className="input-group" id="datepairExample">
                        <label>Registration closes on</label>
                        <input className="date" type="text" defaultValue={this.props.current_selection.stop_date} onChange={this.handleChange}/>
                    </div>
                    <div className="input-group">
                        <button onClick={this.handleUpdate} className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
   } 
});


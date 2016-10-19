var EditorPanel = React.createClass({
    getInitialState: function() {
        return { 
            current_selection: this.props.current_selection

        }
    },
    // getDefaultProps: function() {
    //     return { current_selection: null}
    // },
    // 
    componentWillReceiveProps: function(nextProps) {
      this.setState({
        current_selection: nextProps.current_selection 
      });
    },

    componentDidMount: function() {
        var that = this;
        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {

            that.setItemDate(dateText);
            $('.date').focusout();
          },
          'format': 'm/d/yyyy',
          'autoclose': true
        });

        $('#datepairExample').datepair({
          parseDate: function(input) {

            alert('what the heck');
            return $(input).datepicker('getDate');
          },
          updateDate: function(input, dateObj) {
            alert('nope');
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
            url: '/tickets/' + this.state.current_selection.id,
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
            success: function() {
               //alert('success');
               // this.props.handleDeleteEvent(this.props.event)
               
            }.bind(this)
        });
    },
    setItemDate: function(dateText) {
        ticketObj = this.state.current_selection;
        ticketObj["stop_date"] = dateText;
        console.log(ticketObj);
        this.setState({current_selection: ticketObj})

    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        ticketObj = this.state.current_selection;
        ticketObj[name] = e.target.value;
        this.setState({current_selection: ticketObj});
    },


//     this.RecordForm = React.createClass({
//   handleChange: function(e) {
//     var name, obj;
//     name = e.target.name;
//     return this.setState((
//       obj = {},
//       obj["" + name] = e.target.value,
//       obj
//     ));
//   }
// });

    render: function() {
        return (
            <div className="editor-panel">
            
                <h1>{this.state.current_selection.title}</h1>

                <form>
                    <div className="input-group">
                        <label> Ticket Name</label>
                        <input name="title" type="text" defaultValue={this.state.current_selection.title} value={this.state.current_selection.title} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                        <label> Ticket Active</label>
                        <select name="is_active" defaultValue={this.state.current_selection.is_active} value={this.state.current_selection.is_active} onChange={this.handleChange} >
                            <option value="true">Active</option>
                            <option value="false">Inactive</option>
                          </select>

                    </div>
                    <div className="input-group">
                        <label>Quantity Available</label>
                        <input name="ticket_limit" type="text" defaultValue={this.state.current_selection.ticket_limit} value={this.state.current_selection.ticket_limit} onChange={this.handleChange}  />
                    </div>
                    <div className="input-group">
                        <label>Buy Limit</label>
                        <input name="buy_limit" type="text" defaultValue={this.state.current_selection.buy_limit} value={this.state.current_selection.buy_limit} onChange={this.handleChange}/>
                    </div>
                    <div className="input-group">
                        <label>Description</label>
                        <input name="description" type="text" defaultValue={this.state.current_selection.description} value={this.state.current_selection.description} onChange={this.handleChange} />
                    </div>
                    <div className="input-group" id="datepairExample">
                        <label>Registration closes on</label>
                        <input name="stop_date" className="date" type="text" defaultValue={this.state.current_selection.stop_date} value={this.state.current_selection.stop_date} onChange={this.handleChange}/>
                    </div>
                    <div className="input-group">
                        <button onClick={this.handleUpdate} className="btn btn-primary">Update</button>
                    </div>
                </form>
            </div>
        )
   } 



});


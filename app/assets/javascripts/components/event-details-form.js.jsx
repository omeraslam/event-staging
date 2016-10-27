var EventDetailsForm = React.createClass({
    getInitialState: function() {
        return {eventObj: this.props.eventObj}
    },

    setItemDate: function(dateText) {
        eventObj = this.state.eventObj;
        eventObj["date_start"] = dateText;
        this.setState({eventObj: eventObj})

    },
    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.eventObj;
        obj[name] = e.target.value;
        this.setState({eventObj: obj});
    },


    handleUpdate: function(e) {

        e.preventDefault();
        var method, uri;
      
        method = 'PUT'
        uri = '/events/' + this.state.eventObj.id
        $.ajax({
            method: method,
            url: uri,
            data: {"event": this.state.eventObj},
            dataType: 'JSON',
            success: function() {
               //alert('success');
               //
               
               
            }.bind(this)
        });

        

    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({eventObj: nextProps.eventObj})
    },

    componentDidMount: function() {
        var that = this;
        //format specific 
        this.state.eventObj.date_start = moment(this.state.eventObj.date_start).format('MM/DD/YYYY');
        this.setState({eventObj: this.state.eventObj})
        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {

            that.setItemDate(dateText);
            $('.date').focusout();
          },
          'format': 'MM/DD/YYYY',
          'autoclose': true
        });



          var validator3 = $(".edit-event").validate({
            rules: {
              "name": {
                required: true
              },
              "date_start": {
                required: true
              },
              "location": {
                required: true
              }


            },
            messages: {
              "name": 'Please enter an event name',
              "date_start": 'Please enter an event date',
              "location": 'Please enter an event location'
            }
          });

    },
    render: function() {
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>

                <form className="edit-event">
                    <div className="input-group">
                      <label>Event Name</label>
                      <input name="name" type="text" value={this.state.eventObj.name} onChange={this.handleChange} />
                    </div>

                    <div className="input-group" id="datepairExample">
                        <label>Event Date</label>
                        <input name="date_start" className="date" type="text"  value={this.state.eventObj.date_start} onChange={this.handleChange} />
                    </div>

                    <div className="input-group">
                      <label>Location Address</label>
                      <input name="location" type="text"  value={this.state.eventObj.location} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary" onClick={this.handleUpdate}>Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});
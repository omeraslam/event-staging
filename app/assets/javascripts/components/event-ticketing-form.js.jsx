

var EventTicketingForm = React.createClass({
   getInitialState: function() {
        return { 
            ticketObj: this.props.ticketObj,
            eventObj: this.props.eventObj,
            onPanelUpdate: this.props.onPanelUpdate,
            updateEvent: this.props.onUpdateEventItem,
            tickets_on: this.props.tickets_on,
            advanced_tickets_on: (this.getCookie("advance_tickets_on") == 'true')

        }
    },

    setItemDate: function(dateText) {
        ticketObj = this.state.ticketObj;
        ticketObj["stop_date"] = dateText;
        this.setState({ticketObj: ticketObj})

    },

    setCookie: function(cname, cvalue, exdays) {
        var d = new Date();
        d.setTime(d.getTime() + (exdays*24*60*60*1000));
        var expires = "expires="+d.toUTCString();
        document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";

    },
    getCookie: function(cname) {
        var name = cname + "=";
        var ca = document.cookie.split(';');
        for(var i = 0; i < ca.length; i++) {
            var c = ca[i];
            while (c.charAt(0) == ' ') {
                c = c.substring(1);
            }
            if (c.indexOf(name) == 0) {
                return c.substring(name.length, c.length);
            }
        }
        return "";

    },
    checkCookie: function() {
        var is_advanced_tickets = this.getCookie("advance_tickets_on") == 'true';
       if (is_advanced_tickets != "") {
            //set up advanced tickets
            this.setState({advanced_tickets_on: is_advanced_tickets })
            this.setState({tickets_on: is_advanced_tickets});
            this.props.onTicketUpdate(is_advanced_tickets)
        } else {
            if (is_advanced_tickets != "" && is_advanced_tickets != null) {
                this.setCookie("advance_tickets_on", false, 365);
            }
        }
    },

    componentDidMount: function() {
        var that = this;
        //format specific 
        if(this.state.advanced_tickets_on) {
          $('#toggle-one').bootstrapToggle('on');

        } else {

        $('#toggle-one').bootstrapToggle('off');

        }
        this.checkCookie();

        this.state.ticketObj.stop_date = this.state.ticketObj.stop_date.indexOf('/') > -1 ? this.state.ticketObj.stop_date : moment(this.state.ticketObj.stop_date).format('MM/DD/YYYY');
        this.setState({ticketObj: this.state.ticketObj})
        $('#datepairExample .date').datepicker({
          onSelect: function(dateText) {

            that.setItemDate(dateText);
            $('.date').focusout();
          },
          'format': 'MM/DD/YYYY',
          'autoclose': true
        });


        var validator5 = $(".edit_ticket").validate({
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
            "stop_date": {
              required: true
            },
            "buy_limit": {
              required: true
            },
          }, messages : {
            "title": 'Please enter a ticket name.',
            "price": 'Please enter a ticket price.',
            "ticket_limit": 'Please enter a ticket limit.',
            "buy_limit": 'Please enter a ticket limit.',
            "stop_date": 'Please enter an end date.'

          }
        });


   
    },


    handleUpdate: function(e) {

     e.preventDefault();
        //this.props.current_selection["stop_date"] = moment(this.props.current_selection["stop_date"], "YYYY-MM-DD");
        var method, uri;
        if (this.state.ticketObj.id == null) {
            method = 'POST'
            uri = this.props.eventObj.slug + '/tickets'
        } else {
            method = 'PUT'
            uri = '/tickets/' + this.state.ticketObj.id
        }

        var that = this;

        $.ajax({
            method: method,
            url: uri,
            data: {"ticket" : {
                     "title" : this.state.ticketObj.title, 
                      "ticket_limit" : this.state.ticketObj.ticket_limit, 
                      "buy_limit" : this.state.ticketObj.buy_limit, 
                      "stop_date" : this.state.ticketObj.stop_date
            }},
            dataType: 'JSON',
            success: function() {
              //that.props.onAddedNewItem(this.state.current_selection);
               this.props.onPanelUpdate('Event ticketing settings updated');
               that.state.updateEvent(this.state.eventObj)
               
            }.bind(this)
        });


    },

    handleChange: function(e) {
        var name, obj;
        name = e.target.name;
        obj = this.state.ticketObj;
        obj[name] = e.target.value;
        this.setState({ticketObj: obj});
    },

    handleTicketState: function(e) {
        this.setState({tickets_on: !this.state.tickets_on});
        this.setState({advanced_tickets_on: !this.state.tickets_on});
        this.setCookie("advance_tickets_on", !this.state.tickets_on, 365);
        this.props.onTicketUpdate(!this.state.tickets_on)

    },

    render: function() {

        if(this.state.advanced_tickets_on == true || this.state.tickets_on == true ) {
          var ticketAdvanced = false;
        } else {
          var ticketAdvanced = true;
        }
        return (
            <div>
             <h1>{this.props.header}</h1>
                <p>{this.props.subheader}</p>
                
                <div className="checkbox" onClick={this.handleTicketState}>
                  <label>
                    <input  id="toggle-one" type="checkbox" data-toggle="toggle" value={ticketAdvanced} />
                    Turn on Advanced Ticketing
                  </label>
                </div>


                <form className="edit_ticket">
    

                    <div className="input-group" id="datepairExample">
                      <label>Registration closes on</label>
                      <input name="stop_date" type="text" className="date" value={this.state.ticketObj.stop_date} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Event capacity</label>
                      <input name="ticket_limit" type="text" value={this.state.ticketObj.ticket_limit} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                      <label>Buy Limit</label>
                      <input name="buy_limit" type="text" value={this.state.ticketObj.buy_limit} onChange={this.handleChange} />
                    </div>
                    <div className="input-group">
                        <button className="btn btn-primary" onClick={this.handleUpdate} >Update</button>
                    </div>
                </form>
            </div>
        )
    } 
});



var Events = React.createClass({
    getInitialState: function() {
        return { events: this.props.data }
    },
    getDefaultProps: function() {
        return { events: []}
    },
    deleteEvent: function(event) {
        var index = this.state.events.indexOf(event);
        var events = React.addons.update(this.state.events,
                                          { $splice: [[index, 1]] });
        this.replaceState({ events: events});
    },

    render: function() {
        alert(this.state.events );
        if(this.state.events == '') {
            var eventList = <div className="empty"><h2>Well, this is uneventful; you don't have any events yet. Get on that! </h2><a className="btn btn-obvious" href="/create"><i className="icon icon-plus"></i> create new event</a> </div>;
        } else {
    var eventList =      <div className="events-list">
                        {this.state.events.map(function(event){
                            return <Event key={event.id} event={event} handleDeleteEvent={this.deleteEvent} />
                        }.bind(this))}
                    </div>;
    }


        return (
            <div>
                <div className="event-header container"> 
                    <div className="event-meta">
                        <h1>my events</h1> 
                        <p className="lead">The key to your next big party is at your fingertips. Let's do this.
                        </p>
                    </div>
                    <div className="event-status"> 
                        <div className="event-share">
                            <a href="/create" className="btn btn-obvious"><i className="icon icon-plus"></i>create new event</a>
                            <br/>
                            <p className="small"> New event website and/or invite</p>
                        </div>
                    </div>
                </div>
                <div className="container">
                    {eventList}
                </div>
            </div>
        )
   } 
});


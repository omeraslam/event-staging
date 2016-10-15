var TableElement = React.createClass({
    getInitialState: function() {
        return { attendees: this.props.attendees_list.attendees,
        event: this.props.attendees_list.event }
    },
    getDefaultProps: function() {
        return { attendees: [], event: {}}
    },

    componentDidMount: function() {

    },
    _buildPrintLinkHref: function(e) {
        return '/dashboard/print?event='+ this.props.attendees_list.event.event_id
    },
    _buildDownloadLinkHref: function(e) {
        return '/dashboard/event.csv?event='+ this.props.attendees_list.event.event_id
    },

    render: function() {
        return (
            <div>
            <div className="editor-aside"> 
                <div className="row">
                    <div className="col-md-6">
                        <input className="search selectable table-search-attendees" type="search" placeholder="Search attendees" data-column="all" />
                    </div>
                    <div className="col-md-6 text-right">
                        <a href={this._buildPrintLinkHref()} className="btn btn-primary">Print List </a> <a href={this._buildDownloadLinkHref()} className="btn btn-primary">Download CSV</a>
                   </div>
                </div>
            </div>

            <div className="editor-panel">
                <table className="table tablesorter table-attendees"> 
                            <thead> 
                                <tr> 
                                  <th>First Name</th> 
                                  <th>Last Name</th> 
                                  <th>Email Address</th>  
                                  <th>Ticket Type</th> 
                                  <th> Registration date </th>      
                                </tr> 
                            </thead> 
                            <tbody>

                                {this.state.attendees.map(function(attendee){
                                return <AttendeeRow key={attendee.id} attendee={attendee}  />
                            }.bind(this))}
                            </tbody> 
                        </table>

                </div>
                </div>

        )
   } 
});


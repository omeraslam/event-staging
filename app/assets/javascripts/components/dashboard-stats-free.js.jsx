var DashboardStatsFree = React.createClass({
    render: function() {
        return (
            <div>
                <div className="col-md-4 event-activity-data"><h4>Attendees</h4><h1>{this.props.stats.guest_number} </h1><p>There are {this.props.stats.guest_number} guests attending</p></div>
                <div className="col-md-4 event-activity-data"><h4>Available</h4><h1>{this.props.stats.spots_left} </h1><p>Based on event capacity</p></div>
            </div>

        )
    }
});
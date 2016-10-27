var DashboardStatsFree = React.createClass({
    render: function() {
        return (
            <div>
                <div className="col-md-4 event-activity-data"><h4>Registrations</h4><h1>{this.props.stats.guest_number} </h1><p>Lorem ipsum solor</p></div>
                <div className="col-md-4 event-activity-data"><h4>Spots Open</h4><h1>{this.props.stats.spots_left} </h1><p>Lorem ipsum solor</p></div>
            </div>

        )
    }
});
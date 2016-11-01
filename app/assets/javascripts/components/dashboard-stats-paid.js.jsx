var DashboardStatsPaid = React.createClass({
    render: function() {
        return (
            <div>
                <div className="col-md-4 event-activity-data"><h4>Total revenue</h4><h1>$ {this.props.stats.total_revenue} </h1><p>Your event has made ${this.props.stats.total_revenue}</p></div>
                <div className="col-md-4 event-activity-data"><h4>Tickets Sold</h4><h1>{this.props.stats.guest_number}  </h1><p>You have sold {this.props.stats.guest_number} tickets</p></div>
                <div className="col-md-4 event-activity-data"><h4>Tickets Remaining</h4><h1>{this.props.stats.spots_left} </h1><p>There are {this.props.stats.spots_left} tickets left</p></div>
            </div>

        )
    }
});
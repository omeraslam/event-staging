var DashboardChart = React.createClass({
    componentDidMount: function() {

    },
    render: function() {
        return (
                <div className="col-md-12 event-activity-chart">   
                    <canvas id="myChart" width="400" height="400"></canvas> 
                </div>
            )
    }
})
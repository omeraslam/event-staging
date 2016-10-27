var DashboardContainer = React.createClass({
    getInitialState: function() {
        return {stats: this.props.stats}
    },
    componentDidMount: function() {
        var ctx = document.getElementById("myChart");
        Chart.defaults.global.legend.display = false;

        var myChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ["Red", "Blue", "Yellow", "Green", "Purple", "Orange"],
                datasets: [{
                    label: '# of Votes',
                    data: [12, 19, 3, 5, 2, 3],
                    backgroundColor: [
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)',
                        'rgba(33, 175, 191, .05)'
                    ],
                    borderColor: [
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                        'rgba(33, 175, 191, 1)',
                    ],
                    //borderWidth: 3
                }]
            },
            options: {
                maintainAspectRatio:false,
                responsive:true,
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        },
                          gridLines: {
                            //color:rgba(0,0,0,.5)
                            zeroLineColor: "rgba(0,0,0,0.0)",
                            color:"rgba(0,0,0,0.0)"

                        } 
                    }], 
                    xAxes: [{
                          gridLines: {
                            display:false,
                           color:"rgba(0,0,0,0.0)",
                            zeroLineColor: "rgba(0,0,0,0.0)"

                        } 
                    }]
                }
            }
        });



    },
    render:function() {
        if(this.props.stats.total_revenue == 0) {
            DashboardStats = <DashboardStatsFree stats={this.props.stats} />
        } else {
            DashboardStats = <DashboardStatsPaid stats={this.props.stats}/>
        }

        return (
            <div className="editor-tool editor-panel-primary" id="editor-tool-dashboard">
               <div className="editor-aside">
                    <section>
                        <h4>Status </h4>
                        <div className="event-activity-meter"><span> </span> <div className="event-activity-status"><h5>Live </h5> <p> Your event website is live and ready to share.</p> </div> </div>
                        <div className="event-activity-meter"><span> </span> <div className="event-activity-status"><h5>Registration open </h5> <p> Your event is currently accepting regisations.</p> </div> </div>
                    </section>

                    <section>
                        <h4>Event URL </h4>
                        <div class="input-group">
                            <input type="text" value="myevent.eventcreate.com" disabled="true" />
                            <p> Lorem ipsum solor sit amet</p>
                        </div>
                    </section>

                    <section>
                        <h4>Share </h4>
                        <a href="#" className="btn btn-primary" id="facebook">Share on Facebook </a>
                        <a href="#" className="btn btn-primary" id="twitter">Share on Twitter </a>
                        <a href="#" className="btn btn-primary" id="instagram">Share on Instagram </a>
                    </section>

                </div>



                <div className="editor-panel">
                    <div className="row"> 

                        {DashboardStats}

                    <div className="col-md-12 event-activity-chart">   
                        <canvas id="myChart" width="400" height="400"></canvas> 
                    </div>

                    </div>



                </div>
            




              


        </div>


        )
    }

})
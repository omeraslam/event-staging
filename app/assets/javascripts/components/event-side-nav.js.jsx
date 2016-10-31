var EditorSideNav = React.createClass({
    getInitialState: function() {
        return {event:this.props.event}
    },
    componentWillReceiveProps: function(nextProps) {
        alert(nextProps.event.slug)
        this.setState({
            event: nextProps.event
        })
    },
    componentDidMount: function() {
      //INTRO - slide in the editor tabs
      // setTimeout(function(){  
      //   $('.tabs').addClass("visible");
      // }, 500);



  //EDITOR - set size of panel
  $('.event-editor-sections').css("height",$(window).height());
  $( window ).resize(function() {
    $('.event-editor-sections').css("height",$(window).height());
  });

  //EDITOR -  editor panel interaction behaviors
  $('.toggleEditorPanel').click(function() {

    var active = $(this).hasClass('active');
    var target = $(this).data('target');
    $('.toggleEditorPanel.active').removeClass("active");
    if (!active) {
      $(".editor-tool").hide();
      $(".editor-tool#" + target).show();
      $(this).addClass("active");
      $(".event-editor-section-container").addClass("visible");
    } else {
      $(this).removeClass("active");
      $(".event-editor-section-container").removeClass("visible");
    }
  });

  $('#editor-panel-close').click(function() {
    $(".toggleEditorPanel.active").removeClass("active");
    $(".event-editor-section-container").removeClass("visible");
   });

    },
    render: function() {
        return (

            <div className="event-nav-container">
                <div className="event-nav-top">
                    <a className="event-nav-logo"> 
                        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 255.9 276.6"><path d="M255.8 0.7c0 10.8 0 19.6 0 30.8 -39.9 0.1-79.3-0.4-118.6 0.3C92.9 32.5 60.7 54 42 93.8c-18.7 39.8-14.5 78.4 12.8 113.1 19.4 24.7 45.5 38.1 77.2 38.7 30.4 0.5 60.7 0 92.4 0 0-10.4 0-19.7 0-31.3 -27.6 0-55.2 0.2-82.9 0.1 -48.7-0.1-82.8-30.1-83.1-73.2 -0.3-45.6 34-78.2 82.9-78.5 37.5-0.2 75-0.1 113.9-0.2 0 31 0.1 61 0.1 92.2 -41.8 0.1-83.5 0.1-126.3 0.2 0-9.3 0-18.1 0-28.9 31 0 62.4-0.1 95.2-0.1 0-11.2 0-20.5 0-31.7 -31.9 0-64.1-1.4-96.1 0.6 -23 1.5-40 25.5-38.3 48.6 1.6 21.8 19.3 39 43 39.6 33.7 0.8 67.4 0.2 101.1 0.1 7 0 14 0 22 0 0 31.1 0.1 60.7 0.1 93.3 -14.1 0-28.7 0.4-43.2 0 -35.5-0.9-71.8 2-106.5-4C40 261.1-4 198.9 0.3 130.1 4.5 62.8 58.2 5.2 123.8 1.3 167-1.2 210.4 0.7 255.8 0.7z" fill="#FFF"/></svg>   
                    </a>

                    <a className="event-nav-link toggleEditorPanel" id="editor-tool-dashboard" data-target="editor-tool-dashboard">
                        <i className="icon icon-home"> </i> <span> Dashboard </span>
                    </a> 

                    <a className="event-nav-link toggleEditorPanel" id="editor-tool-attendees" data-target="editor-tool-attendees" >
                        <i className="icon icon-users"> </i> <span> Attendees</span>
                    </a>   

                    <a className="event-nav-link toggleEditorPanel" id="editor-tool-orders" data-target="editor-tool-orders" >
                        <i className="icon icon-doc-lines"> </i> <span> Orders</span>
                    </a>  

                    
       
                    <a className="event-nav-link" href={'/' + this.state.event.slug} target="_blank"><i className="icon icon-eye"> </i> <span> Preview</span></a>  
                </div>
                <div className="event-nav-bottom">
                    <a className="event-nav-link toggleDesignPanel" id="editor-tool-background" data-target="editor-tool-background">
                        <i className="icon icon-image"> </i> <span> Design </span>
                    </a> 

                    <a className="event-nav-link toggleEditorPanel" id="editor-tool-details" data-target="editor-tool-details"  >
                        <i className="icon icon-settings"> </i> <span> Settings</span>
                    </a> 

                    <a className="event-nav-link toggleEditorPanel" id="editor-tool-ticketing" data-target="editor-tool-ticketing" >
                        <i className="fa fa-fw fa-ticket"> </i> <span> Tickets</span>
                          <div className="editor-tab-notification editor-tab-notification-error"></div>
                       
                    </a>    
                    <a className="event-nav-link toggleEditorPanel" id="editor-tool-questions" data-target="editor-tool-questions" >
                        <i className="icon icon-question"> </i> <span> Questions</span>
                    </a>       

                    <a className="event-nav-link toggleEditorPanel" id="editor-tool-coupons" data-target="editor-tool-coupons" >
                        <i className="fa fa-fw fa-tag"> </i> <span> Coupons</span>
                    </a>       

                </div>
            </div>



        )
    }
})


                        // TODO - account == nil and ticket price != 0
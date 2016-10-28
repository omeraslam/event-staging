var EditorDesign = React.createClass({
    getInitialState: function() {
        return {eventObj: this.props.eventObj}
    },

    componentWillReceiveProps: function(nextProps) {
        this.setState({eventObj: nextProps.eventObj})
    },
    componentDidMount: function() {

        $('#design-panel-close').click(function() {
            $(".design-editor-section-container").removeClass("visible");
        });

        $('.toggleDesignPanel').click(function() {
            $(".design-editor-section-container").addClass("visible");

            $(".toggleEditorPanel.active").removeClass("active");
            $(".event-editor-section-container").removeClass("visible");

        });

          $('.upload-btn').on('click', function(){
            $('.file-label').click();
          });

  var imageModal = $('#image-search-modal').remodal();

          $('.open-image-modal').click(function(e){
          e.preventDefault();
          imageModal.open();
      });



        //DESIGN > LAYOUT 
        //contruct the layout selector based on html visibility
        $(".test-show-layout").each(function() {

            var target = $(this).data("target");
            if ($(target).hasClass("hidden")) {       
              $(this).addClass("inactive");

            } 
        });


      
        //DESIGN > LAYOUT 
        //click handler for layout select
        $(".test-show-layout").on( "click", function() {
          
          var target = $(this).data("target");
          
          if ($(target).hasClass("hidden")) { 
            
            $(target).removeClass("hidden");
            $(this).removeClass("inactive");
            $('html, body').animate({
              scrollTop: $(target).offset().top - 50
            }, 200);


            htmlHeroOne = $("#htmlHeroOne").froalaEditor('html.get');
            htmlBodyOne = $("#htmlBodyOne").froalaEditor('html.get');
            htmlFooterOne = $("#htmlFooterOne").froalaEditor('html.get');

            saveChanges();

          } else {
            
            $(target).addClass("hidden");
            $(this).addClass("inactive");

            htmlHeroOne = $("#htmlHeroOne").froalaEditor('html.get');
            htmlBodyOne = $("#htmlBodyOne").froalaEditor('html.get');
            htmlFooterOne = $("#htmlFooterOne").froalaEditor('html.get');

            saveChanges();

          }
        
        });


    },
    render: function() {


        var imgUrl = this.state.eventObj.background_img == undefined  ? '/assets/themes/default_bg.jpg' : this.state.eventObj.background_img.url;
        if(this.state.eventObj.external_image != '') {
            imgUrl = this.state.eventObj.external_image;
        }
        //alert(imgUrl);
        var divStyle = {
            backgroundImage: 'url(' + imgUrl + ')'
        }


       // alert(divStyle.backgroundImage)


        return (

            <div className="design-editor-section-container">
                <div className="design-editor-header text-right">
                    <a id="design-panel-close"><i className="icon icon-arrow-left"> </i></a>
                </div>

                <div className="design-editor-body">
                    <section>
                        <h4>Layout </h4>
                        <p>Show or hide sections of your event website. </p>
                        <div className=" layout-select">
                            <ul> 
                                <li className="test-show-layout"  data-target="#about">About <i className="fa fa-eye"> </i></li>
                                <li className="test-show-layout" data-target="#speakers">Speakers <i className="fa fa-eye"> </i></li>
                                <li className="test-show-layout" data-target="#program">Program/Schedule <i className="fa fa-eye"> </i></li>
                                <li className="test-show-layout" data-target="#sponsors">Sponsors <i className="fa fa-eye"> </i></li>
                            </ul>
                        </div>
                    </section>
                    <section>
                        <h4>Background image/color </h4>
                        <p>Modify your website's main background here. </p>
                        <div className="editor-current-bg upload-btn" style={divStyle} > </div>  
                        <a className="upload-btn btn btn-small"> <i className="fa fa-upload"> </i> Upload image </a> 
                        <a className="open-image-modal btn btn-small"> <i className="fa fa-search"> </i> Search image library </a> 
                    </section>  
                    <section>
                        <div className="slider-container">
                            <div className="slider"> <div id="slider"></div> </div>
                            <div className="color-picker"><input id="color" /></div>
                        </div>
                    </section>  

                </div>
            </div>
        )
    }
})